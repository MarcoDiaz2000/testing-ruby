class MusicAlbum < Item
  attr_accessor :on_spotify

  @music_album_instances = []

  class << self
    attr_accessor :music_album_instances
  end

  def initialize(genre, author, source, label, publish_date, on_spotify, archived = false)
    @id = next_id
    super(genre, author, source, label, publish_date, archived)
    @on_spotify = on_spotify
    self.class.music_album_instances << self
  end

  def next_id
    file = File.read('musicAlbum.json')
    musicAlbums = JSON.parse(file)
    return 1 if musicAlbums.empty?

    max_id = musicAlbums.max_by { |musicAlbum| musicAlbum['id'] }['id']
    max_id + 1
  end

  def to_s
    "#{@id} - #{on_spotify ? 'Available' : 'Not available'} on Spotify"
  end

    def self.find_by_id(id)
    music_album_instances.find { |musicAlbum| musicAlbum.id == id }
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
      'on_spotify' => @on_spotify,
    }.to_json(*args)
  end

  def self.json_create(object)
    genre = Genre.find_by_id(object['genre'])
    author = Author.find_by_id(object['author'])
    source = Source.find_by_id(object['source'])
    label = Label.find_by_id(object['label'])
    publish_date = Date.parse(object['publish_date'])
    on_spotify = object['on_spotify']
    archived = object['archived']

    music_album = new(genre, author, source, label, publish_date, on_spotify, archived)
    music_album.instance_variable_set(:@id, object['id'])
    music_album
  end

  def can_be_archived?
    super && @on_spotify
  end
end