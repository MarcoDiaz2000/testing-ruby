class Game < Item
  attr_accessor :multiplayer, :last_played_at

  @game_instances = []

  class << self
    attr_accessor :game_instances
  end

  def initialize(json_file, genre, author, source, label, publish_date, multiplayer, last_played_at, archived = false)
    super(json_file, genre, author, source, label, publish_date, archived)
    @multiplayer = multiplayer
    @last_played_at = last_played_at
    move_to_archive
    self.class.game_instances << self
  end

  def self.find_by_id(id)
    game_instances.find { |game| game.id == id }
  end

  def to_json(*args)
    {
      JSON.create_id => self.class.name,
      'id' => @id,
      'genre' => @genre.id,
      'author' => @author.id,
      'source' => @source.id,
      'label' => @label.id,
      'publish_date' => @publish_date,
      'archived' => @archived,
      'multiplayer' => @multiplayer,
      'last_played_at' => @last_played_at,
    }.to_json(*args)
  end

  def self.json_create(object)
    genre = Genre.find_by_id(object['genre'])
    author = Author.find_by_id(object['author'])
    source = Source.find_by_id(object['source'])
    label = Label.find_by_id(object['label'])
    publish_date = Date.parse(object['publish_date'])
    multiplayer = object['multiplayer']
    last_played_at = Date.parse(object['last_played_at'])
    archived = object['archived']

    game = new('json_file', genre, author, source, label, publish_date, multiplayer, last_played_at, archived)
    game.instance_variable_set(:@id, object['id'])
    game
  end

  def can_be_archived?
    super && Time.now.year - @last_played_at.year > 2
  end
end