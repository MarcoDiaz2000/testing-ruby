class Source
  attr_accessor :id, :name, :items

  @source_instances = []

  class << self
    attr_accessor :source_instances
  end

  def initialize(name)
    @id = next_id
    @name = name
    @items = []
    self.class.source_instances << self
  end

  def next_id
    file = File.read('source.json')
    sources = JSON.parse(file)
    return 1 if sources.empty?
  
    max_id = sources.max_by { |s| s['id'] }['id']
    max_id + 1
  end

  def add_item(item)
    @items << item
    item.source = self
  end

  def to_json(*args)
    {
      JSON.create_id => self.class.name,
      'id' => @id,
      'name' => @name,
      'items' => @items.map { |item| [item.id, item.class.to_s] }
    }.to_json(*args)
  end

  def self.json_create(object)
    source = new(object['name'])
    source.instance_variable_set(:@id, object['id'])
    object['items'].each do |item_id, item_class_name|
      source.add_item(Object.const_get(item_class_name).find_by_id(item_id))
    end
    source
  end

  def self.find_by_id(id)
    source_instances.find { |source| source.id == id }
  end
end
