class Book < Item
  attr_accessor :publisher, :cover_state

  @book_instances = []

  class << self
    attr_accessor :book_instances
  end

  def initialize(params)
    super(params)
    @publisher = params[:publisher]
    @cover_state = params[:cover_state]
    move_to_archive
    self.class.book_instances << self
  end

  def self.find_by_id(id)
    book_instances.find { |book| book.id == id }
  end

  def to_json(*args)
    {
      JSON.create_id => self.class.name,
      'id' => @id,
      'genre' => @genre.id,
      'author' => @author.id,
      'source' => @source.id,
      'label' => @label.id,
      'publish_date' => @publish_date.to_s,
      'archived' => @archived,
      'publisher' => @publisher,
      'cover_state' => @cover_state
    }.to_json(*args)
  end

  def can_be_archived?
    super || @cover_state == 'bad'
  end

  def self.json_create(object)
    params = extract_params_from_json(object)

    book = new(params)
    book.instance_variable_set(:@id, object['id'])
    book
  end

  def self.extract_params_from_json(object)
    {
      json_file: 'json_file',
      genre: Genre.find_by_id(object['genre']),
      author: Author.find_by_id(object['author']),
      source: Source.find_by_id(object['source']),
      label: Label.find_by_id(object['label']),
      publish_date: Date.parse(object['publish_date']),
      publisher: object['publisher'],
      cover_state: object['cover_state'],
      archived: object['archived']
    }
  end
end
