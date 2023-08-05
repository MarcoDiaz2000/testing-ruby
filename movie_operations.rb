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