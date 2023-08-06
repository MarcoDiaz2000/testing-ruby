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
    else
      @genres.each { |genre| puts "ID: #{genre.id}, Name: #{genre.name}" }
      puts 'Enter 0 to create a new genre.'
      input = gets.chomp.to_i
      return @genres.find { |genre| genre.id == input } unless input.zero?




    end
    create
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
