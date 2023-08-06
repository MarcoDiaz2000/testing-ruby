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
      books_from_json = JSON.parse(book_data)
      books_from_json.each do |book_hash|
        @books << Book.json_create(book_hash)
      end
    else
      @books = []
    end
  end

  def list
    @books.each do |book| 
      puts "id: #{book.id}, Publisher #{book.publisher}, Cover #{book.cover_state} - Genre: #{book.genre.name} - Author: #{book.author.first_name} #{book.author.last_name} - Source: #{book.source.name} - Label: #{book.label.title} #{book.label.color_name} - Published: #{book.publish_date}"
    end
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
  
    puts 'Enter the publish date (YYYY-MM-DD):'
    publish_date_input = gets.chomp
    publish_date = Date.parse(publish_date_input)
  
    book = Book.new('book.json', genre, author, source, label, publish_date, publisher, cover_state)
    @books << book
    puts 'Book added successfully'
  end

  def save
    File.write('book.json', JSON.dump(@books))
  end
end