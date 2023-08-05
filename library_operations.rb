require 'json'
require 'date'
require_relative 'item'
require_relative 'author'
require_relative 'author_operations'
require_relative 'source'
require_relative 'source_operations'
require_relative 'genre'
require_relative 'genre_operations'
require_relative 'label'
require_relative 'label_operations'
require_relative 'book'
require_relative 'book_operations'
require_relative 'game'
require_relative 'game_operations'
require_relative 'movie'
require_relative 'movie_operations'
require_relative 'music_album'
require_relative 'music_album_operations'


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