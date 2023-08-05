class Book < Item
  attr_accessor :publisher, :cover_state

  @book_instances = []

  class << self
    attr_accessor :book_instances
  end

  def initialize(genre, author, source, label, publish_date, publisher, cover_state, archived = false)
    @id = next_id
    super(genre, author, source, label, publish_date, archived)
    @publisher = publisher
    @cover_state = cover_state
    self.class.book_instances << self
  end

  def next_id
    file = File.read('book.json')
    books = JSON.parse(file)
    return 1 if books.empty?

    max_id = books.max_by { |book| book['id'] }['id']
    max_id + 1
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

  def self.json_create(object)
    genre = Genre.find_by_id(object['genre'])
    author = Author.find_by_id(object['author'])
    source = Source.find_by_id(object['source'])
    label = Label.find_by_id(object['label'])
    publish_date = Date.parse(object['publish_date'])
    publisher = object['publisher']
    cover_state = object['cover_state']
    archived = object['archived']

    book = new(genre, author, source, label, publish_date, publisher, cover_state, archived)
    book.instance_variable_set(:@id, object['id'])
    book
  end

  def can_be_archived?
    super || @cover_state == 'bad'
  end
end
