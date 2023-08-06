class MusicAlbum < Item
  attr_accessor :on_spotify

  @music_album_instances = []

  class << self
    attr_accessor :music_album_instances
  end

  def initialize(params)
    super(params)
    @on_spotify = params[:on_spotify]
    move_to_archive
    self.class.music_album_instances << self
  end

  def self.find_by_id(id)
    music_album_instances.find { |music_album| music_album.id == id }
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
      'on_spotify' => @on_spotify
    }.to_json(*args)
  end

  def self.json_create(object)
    params = extract_params_from_json(object)

    music_album = new(params)
    music_album.instance_variable_set(:@id, object['id'])
    music_album
  end

  def self.extract_params_from_json(object)
    {
      json_file: 'music_album.json',
      genre: Genre.find_by_id(object['genre']),
      author: Author.find_by_id(object['author']),
      source: Source.find_by_id(object['source']),
      label: Label.find_by_id(object['label']),
      publish_date: Date.parse(object['publish_date']),
      on_spotify: object['on_spotify'],
      archived: object['archived']
    }
  end

  def can_be_archived?
    super && @on_spotify
  end
end
