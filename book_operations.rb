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