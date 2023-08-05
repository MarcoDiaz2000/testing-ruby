require 'json'
require 'date'

class Item
  attr_accessor :id, :publish_date, :archived, :author, :source, :label, :genre

  def initialize(id, genre, author, source, label, publish_date, archived = false)
    @id = id
    @genre = genre
    @author = author
    @source = source
    @label = label
    @publish_date = publish_date
    @archived = archived
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
      'archived' => @archived
    }.to_json(*args)
  end

  def can_be_archived?
    Time.now.year - @publish_date.year > 10
  end

  def move_to_archive
    @archived = true if can_be_archived?
  end
end



class Source
  attr_accessor :id, :name, :items

  def initialize(name)
    @id = next_id
    @name = name
    @items = []
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
end






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
    object['items'].each do |item_id, item_class_name|
      genre.add_item(Object.const_get(item_class_name).find_by_id(item_id))
    end
    genre
  end
end




class Author
  attr_accessor :id, :first_name, :last_name, :items

  def initialize(first_name, last_name)
    @id = next_id
    @first_name = first_name
    @last_name = last_name
    @items = []
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
end




class Label
  attr_accessor :id, :title, :color_name, :items

  def initialize(title, color_name)
    @id = next_id
    @title = title
    @color_name = color_name
    @items = []
  end
  
  def next_id
    file = File.read('label.json')
    labels = JSON.parse(file)
    return 1 if labels.empty?
  
    max_id = labels.max_by { |l| l['id'] }['id']
    max_id + 1
  end

  def add_item(item)
    @items << item
    item.label = self
  end

  def to_json(*args)
    {
      JSON.create_id => self.class.name,
      'id' => @id,
      'title' => @title,
      'color_name' => @color_name,
      'items' => @items.map { |item| [item.id, item.class.to_s] }
    }.to_json(*args)
  end

  def self.json_create(object)
    label = new(object['title'], object['color_name'])
    label.instance_variable_set(:@id, object['id'])
    label.instance_variable_set(:@items, object['items'])
    label
  end
end



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




class Movie < Item
  attr_accessor :silent

  @movie_instances = []

  class << self
    attr_accessor :movie_instances
  end

  def initialize(genre, author, source, label, publish_date, silent, archived = false)
    @id = next_id
    super(genre, author, source, label, publish_date, archived)
    @silent = silent
    self.class.movie_instances << self
  end

  def next_id
    file = File.read('movie.json')
    movies = JSON.parse(file)
    return 1 if movies.empty?

    max_id = movies.max_by { |movie| movie['id'] }['id']
    max_id + 1
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
      'silent' => @silent,
    }.to_json(*args)
  end

  def self.json_create(object)
    genre = Genre.find_by_id(object['genre'])
    author = Author.find_by_id(object['author'])
    source = Source.find_by_id(object['source'])
    label = Label.find_by_id(object['label'])
    publish_date = Date.parse(object['publish_date'])
    silent = object['silent']
    archived = object['archived']

    movie = new(genre, author, source, label, publish_date, silent, archived)
    movie.instance_variable_set(:@id, object['id'])
    movie
  end

  def can_be_archived?
    super || @silent
  end
end





class Game < Item
  attr_accessor :multiplayer, :last_played_at

  @game_instances = []

  class << self
    attr_accessor :game_instances
  end

  def initialize(genre, author, source, label, publish_date, multiplayer, last_played_at, archived = false)
    @id = next_id
    super(genre, author, source, label, publish_date, archived)
    @multiplayer = multiplayer
    @last_played_at = last_played_at
    self.class.game_instances << self
  end

  def next_id
    file = File.read('game.json')
    games = JSON.parse(file)
    return 1 if games.empty?

    max_id = games.max_by { |game| game['id'] }['id']
    max_id + 1
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

    game = new(genre, author, source, label, publish_date, multiplayer, last_played_at, archived)
    game.instance_variable_set(:@id, object['id'])
    game
  end

  def can_be_archived?
    super && Time.now.year - @last_played_at.year > 2
  end
end





def print_menu
  puts "Choose an option:"
  puts "1. List all books"
  puts "2. List all music albums"
  puts "3. List all movies"
  puts "4. List all games"
  puts "5. List all genres"
  puts "6. List all labels"
  puts "7. List all authors"
  puts "8. List all sources"
  puts "9. Add a book"
  puts "10. Add a music album"
  puts "11. Add a movie"
  puts "12. Add a game"
  puts "13. Exit"
end




class LibraryOperations
  ACTIONS = {
    1 => :list_books,
    2 => :list_music_albums,
    3 => :list_movies,
    4 => :list_games,
    5 => :list_genres,
    6 => :list_labels,
    7 => :list_authors,
    8 => :list_sources,
    9 => :add_book,
    10 => :add_music_album,
    11 => :add_movie,
    12 => :add_game,
    13 => :exit_program
  }.freeze

  def initialize
    @genre_operations = GenreOperations.new
    @label_operations = LabelOperations.new
    @author_operations = AuthorOperations.new
    @source_operations = SourceOperations.new
    @book_operations = BookOperations.new(@genre_operations, @label_operations, @author_operations, @source_operations)
    @music_album_operations = MusicAlbumOperations.new(@genre_operations, @label_operations, @author_operations, @source_operations)
    @movie_operations = MovieOperations.new(@genre_operations, @label_operations, @author_operations, @source_operations)
    @game_operations = GameOperations.new(@genre_operations, @label_operations, @author_operations, @source_operations)
  end

  def list_books
    @book_operations.list
  end

  def list_music_albums
    @music_album_operations.list
  end

  def list_movies
    @movie_operations.list
  end

  def list_games
    @game_operations.list
  end

  def list_genres
    @genre_operations.list
  end

  def list_labels
    @label_operations.list
  end

  def list_authors
    @author_operations.list
  end

  def list_sources
    @source_operations.list
  end

  def add_book
    @book_operations.add
  end

  def add_music_album
    @music_album_operations.add
  end

  def add_movie
    @movie_operations.add
  end

  def add_game
    @game_operations.add
  end

  def exit_program

    @book_operations.save
    @miusic_album_operations.save
    @movie_operations.save
    @game_operations.save
    @genre_operations.save
    @label_operations.save
    @author_operarions.save
    @source_operations.save
    puts 'Goodbye!'
    exit
  end

  def execute_option(option)
    if ACTIONS.key?(option)
      send(ACTIONS[option])
    else
      puts 'Invalid selection. Please choose a valid option.'
    end
  end
end



class LabelOperations
  def initialize
    @labels = []
    load_labels
  end

  def load_labels
    if File.exist?('label.json')
      label_data = File.read('label.json')
      JSON.parse(label_data, create_additions: true).each do |label|
        @labels << label
      end
    else
      @labels = []
    end
  end

  def list
    if @labels.empty?
      puts 'The next step is to select a label, but the list is empty, please create a new label.'
      create
    else
      @labels.each { |label| puts "ID: #{label.id}, Title: #{label.title}" }
      puts 'Enter 0 to create a new label.'
      input = gets.chomp.to_i
      if input == 0
        create
      else
        return @labels.find { |label| label.id == input }
      end
    end
  end

  def create
    puts 'Enter the new label:'
    title = gets.chomp
    puts 'Enter the color name:'
    color_name = gets.chomp
    label = Label.new(title, color_name)
    @labels << label
    save
    puts 'Label created successfully'
    list
  end

  def save
    File.write('label.json', JSON.dump(@labels))
  end

  def find_by_id(id)
    @labels.find { |label| label.id == id }
  end
end




class GenreOperations
  def initialize
    @genres = []
    load_genres
  end

  def load_genres
    if File.exist?('genre.json')
      genre_data = File.read('genre.json')
      genres = JSON.parse(genre_data, create_additions: true)
      @genres = genres
    else
      @genres = []
    end
  end

  def list
    if @genres.empty?
      puts 'The next step is to select an genre, but the list is empty, please create a new genre.'
      create
    else
      @genres.each { |genre| puts "ID: #{genre.id}, Name: #{genre.name}" }
      puts 'Enter 0 to create a new genre.'
      input = gets.chomp.to_i
      if input == 0
        create
      else
        return @genres.find { |genre| genre.id == input }
      end
    end
  end
  
  

  def create
    puts 'Enter the new genre:'
    genre_name = gets.chomp
    genre = Genre.new(genre_name)
    @genres << genre
    save
    puts 'Genre created successfully'
    list
  end

  def save
    File.write('genre.json', JSON.dump(@genres))
  end

  def find_by_id(id)
    @genres.find { |genre| genre.id == id }
  end
end





class AuthorOperations
  def initialize
    @authors = []
    load_authors
  end

  def load_authors
    if File.exist?('author.json')
      author_data = File.read('author.json')
      JSON.parse(author_data, create_additions: true).each do |author|
        @authors << author
      end
    else
      @authors = []
    end
  end

  def list
    if @authors.empty?
      puts 'The next step is to select an author, but the list is empty, please create a new author.'
      create
    else
      @authors.each { |author| puts "ID: #{author.id}, Name: #{author.first_name} #{author.last_name}" }
      puts 'Enter 0 to create a new author.'
      input = gets.chomp.to_i
      if input == 0
        create
      else
        return @authors.find { |author| author.id == input }
      end
    end
  end

  def create
    puts 'Enter the first name of the author:'
    first_name = gets.chomp
    puts 'Enter the last name of the author:'
    last_name = gets.chomp
    author = Author.new(first_name, last_name)
    @authors << author
    save
    puts 'Author created successfully'
    list
  end

  def save
    File.write('author.json', JSON.dump(@authors))
  end

  def find_by_id(id)
    @authors.find { |author| author.id == id }
  end
end






class SourceOperations
  def initialize
    @sources = []
    load_sources
  end

  def load_sources
    if File.exist?('source.json')
      source_data = File.read('source.json')
      JSON.parse(source_data, create_additions: true).each do |source|
        @sources << source
      end
    else
      @sources = []
    end
  end

  def list
    if @sources.empty?
      puts 'The next step is to select a source, but the list is empty, please create a new source.'
      create
    else
      @sources.each { |source| puts "ID: #{source.id}, Name: #{source.name}" }
      puts 'Enter 0 to create a new source.'
      input = gets.chomp.to_i
      if input == 0
        create
      else
        return @sources.find { |source| source.id == input }
      end
    end
  end

  def create
    puts 'Enter the name of the source:'
    source_name = gets.chomp
    source = Source.new(source_name)
    @sources << source
    save
    puts 'Source created successfully'
    list
  end

  def save
    File.write('source.json', JSON.dump(@sources))
  end

  def find_by_id(id)
    @sources.find { |source| source.id == id }
  end
end





class BookOperations
  def initialize(genre_operations, label_operations, author_operations, source_operations)
    @genre_operations = genre_operations
    @label_operations = label_operations
    @author_operations = author_operations
    @source_operations = source_operations
    @books = []
    load_books
  end

  def load_books
    if File.exist?('book.json')
      book_data = File.read('book.json')
      JSON.parse(book_data, create_additions: true).each do |book|
        @books << book
      end
    else
      @books = []
    end
  end

  def list
    @books.each { |book| puts "#{book.id}. #{book.publisher} - #{book.cover_state}" }
  end

  def add
    puts 'Enter the publisher:'
    publisher = gets.chomp
  
    puts 'Enter the cover state:'
    cover_state = gets.chomp
  
    genre = @genre_operations.list

    author = @author_operations.list

    source = @source_operations.list

    label = @label_operations.list
  
    publish_date = Date.today
  
    book = Book.new(genre, author, source, label, publish_date, publisher, cover_state)
    @books << book
    puts 'Book added successfully'
  end

  def save
    File.write('book.json', JSON.dump(@books))
  end
end






class MusicAlbumOperations
  def initialize(genre_operations, label_operations, author_operations, source_operations)
    @genre_operations = genre_operations
    @label_operations = label_operations
    @author_operations = author_operations
    @source_operations = source_operations
    @albums = []
    load_albums
  end

  def load_albums
    if File.exist?('album.json')
      album_data = File.read('album.json')
      JSON.parse(album_data, create_additions: true).each do |album|
        @albums << album
      end
    else
      @albums = []
    end
  end

  def list
    @albums.each { |album| puts "#{album.id}. #{album.name} - #{album.on_spotify ? 'Available' : 'Not available'} on Spotify" }
  end

  def add
    puts 'Enter the album name:'
    name = gets.chomp

    puts 'Is the album available on Spotify? (Y/N):'
    on_spotify = gets.chomp.downcase == 'y' ? true : false

    puts 'Enter the genre id:'
    genre_id = gets.chomp.to_i
    genre = @genre_operations.find_by_id(genre_id)

    puts 'Enter the author id:'
    author_id = gets.chomp.to_i
    author = @author_operations.find_by_id(author_id)

    puts 'Enter the source id:'
    source_id = gets.chomp.to_i
    source = @source_operations.find_by_id(source_id)

    puts 'Enter the label id:'
    label_id = gets.chomp.to_i
    label = @label_operations.find_by_id(label_id)

    publish_date = Date.today

    album = MusicAlbum.new(genre, author, source, label, publish_date, name, on_spotify)
    @albums << album
    puts 'Album added successfully'
  end

  def save
    File.write('album.json', JSON.dump(@albums))
  end
end





class MovieOperations
  def initialize(genre_operations, label_operations, author_operations, source_operations)
    @genre_operations = genre_operations
    @label_operations = label_operations
    @author_operations = author_operations
    @source_operations = source_operations
    @movies = []
    load_movies
  end

  def load_movies
    if File.exist?('movie.json')
      movie_data = File.read('movie.json')
      JSON.parse(movie_data, create_additions: true).each do |movie|
        @movies << movie
      end
    else
      @movies = []
    end
  end

  def list
    @movies.each { |movie| puts "#{movie.id}. #{movie.name} - Silence: #{movie.silent ? 'Yes' : 'No'}" }
  end

  def add
    puts 'Enter the movie name:'
    name = gets.chomp

    puts 'Is the movie silent? (Y/N):'
    silent = gets.chomp.downcase == 'y' ? true : false

    puts 'Enter the genre id:'
    genre_id = gets.chomp.to_i
    genre = @genre_operations.find_by_id(genre_id)

    puts 'Enter the author id:'
    author_id = gets.chomp.to_i
    author = @author_operations.find_by_id(author_id)

    puts 'Enter the source id:'
    source_id = gets.chomp.to_i
    source = @source_operations.find_by_id(source_id)

    puts 'Enter the label id:'
    label_id = gets.chomp.to_i
    label = @label_operations.find_by_id(label_id)

    publish_date = Date.today

    movie = Movie.new(genre, author, source, label, publish_date, name, silent)
    @movies << movie
    puts 'Movie added successfully'
  end

  def save
    File.write('movie.json', JSON.dump(@movies))
  end
end





class GameOperations
  def initialize(genre_operations, label_operations, author_operations, source_operations)
    @genre_operations = genre_operations
    @label_operations = label_operations
    @author_operations = author_operations
    @source_operations = source_operations
    @games = []
    load_games
  end

  def load_games
    if File.exist?('game.json')
      game_data = File.read('game.json')
      JSON.parse(game_data, create_additions: true).each do |game|
        @games << game
      end
    else
      @games = []
    end
  end

  def list
    @games.each { |game| puts "#{game.id}. #{game.name} - Multiplayer: #{game.multiplayer ? 'Yes' : 'No'} - Last played at: #{game.last_played_at}" }
  end

  def add
    puts 'Enter the game name:'
    name = gets.chomp

    puts 'Does the game support multiplayer? (Y/N):'
    multiplayer = gets.chomp.downcase == 'y' ? true : false

    puts 'Enter the last played date (YYYY-MM-DD):'
    last_played_at = Date.parse(gets.chomp)

    puts 'Enter the genre id:'
    genre_id = gets.chomp.to_i
    genre = @genre_operations.find_by_id(genre_id)

    puts 'Enter the author id:'
    author_id = gets.chomp.to_i
    author = @author_operations.find_by_id(author_id)

    puts 'Enter the source id:'
    source_id = gets.chomp.to_i
    source = @source_operations.find_by_id(source_id)

    puts 'Enter the label id:'
    label_id = gets.chomp.to_i
    label = @label_operations.find_by_id(label_id)

    publish_date = Date.today

    game = Game.new(genre, author, source, label, publish_date, name, multiplayer, last_played_at)
    @games << game
    puts 'Game added successfully'
  end

  def save
    File.write('game.json', JSON.dump(@games))
  end
end


