class Movie < Item
  attr_accessor :silent

  @movie_instances = []

  class << self
    attr_accessor :movie_instances
  end

  def initialize(params)
    super(params)
    @silent = params[:silent]
    move_to_archive
    self.class.movie_instances << self
  end

  def self.find_by_id(id)
    movie_instances.find { |movie| movie.id == id }
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
      'silent' => @silent
    }.to_json(*args)
  end

  def self.json_create(object)
    params = extract_params_from_json(object)

    movie = new(params)
    movie.instance_variable_set(:@id, object['id'])
    movie
  end

  def self.extract_params_from_json(object)
    {
      json_file: 'json_file',
      genre: Genre.find_by_id(object['genre']),
      author: Author.find_by_id(object['author']),
      source: Source.find_by_id(object['source']),
      label: Label.find_by_id(object['label']),
      publish_date: Date.parse(object['publish_date']),
      silent: object['silent'],
      archived: object['archived']
    }
  end

  def can_be_archived?
    super || @silent
  end
end
