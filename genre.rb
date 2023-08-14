class Genre
  attr_accessor :id, :name, :items

  @genre_instances = []

  class << self
    attr_accessor :genre_instances
  end

  def initialize(name)
    @id = next_id
    @name = name
    @items = []
    self.class.genre_instances << self
  end

  def next_id
    file = File.read('genre.json')
    genres = JSON.parse(file)
    return 1 if genres.empty?

    max_id = genres.max_by { |g| g['id'] }['id']
    max_id + 1
  end

  def details
    "ID: #{@id}, Name: #{@name}"
  end

  def self.find_by_id(id)
    genre_instances.find { |genre| genre.id == id }
  end

  def add_item(item)
    @items << item
    item.genre = self
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
    genre = new(object['name'])
    genre.instance_variable_set(:@id, object['id'])
    genre.instance_variable_set(:@items, object['items'])
    genre
  end
end
