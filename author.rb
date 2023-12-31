class Author
  attr_accessor :id, :first_name, :last_name, :items

  @author_instances = []

  class << self
    attr_accessor :author_instances
  end

  def initialize(first_name, last_name)
    @id = next_id
    @first_name = first_name
    @last_name = last_name
    @items = []
    self.class.author_instances << self
  end

  def next_id
    file = File.read('author.json')
    authors = JSON.parse(file)
    return 1 if authors.empty?

    max_id = authors.max_by { |a| a['id'] }['id']
    max_id + 1
  end

  def add_item(item)
    @items << item
    item.author = self
  end

  def to_json(*args)
    {
      JSON.create_id => self.class.name,
      'id' => @id,
      'first_name' => @first_name,
      'last_name' => @last_name,
      'items' => @items.map { |item| [item.id, item.class.to_s] }
    }.to_json(*args)
  end

  def self.json_create(object)
    author = new(object['first_name'], object['last_name'])
    author.instance_variable_set(:@id, object['id'])
    object['items'].each do |item_id, item_class_name|
      author.add_item(Object.const_get(item_class_name).find_by_id(item_id))
    end
    author
  end

  def self.find_by_id(id)
    author_instances.find { |author| author.id == id }
  end
end
