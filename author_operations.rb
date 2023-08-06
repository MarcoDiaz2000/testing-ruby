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
    else
      @authors.each { |author| puts "ID: #{author.id}, Name: #{author.first_name} #{author.last_name}" }
      puts 'Enter 0 to create a new author.'
      input = gets.chomp.to_i
      return @authors.find { |author| author.id == input } unless input.zero?




    end
    create
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
