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
    else
      @sources.each { |source| puts "ID: #{source.id}, Name: #{source.name}" }
      puts 'Enter 0 to create a new source.'
      input = gets.chomp.to_i
      return @sources.find { |source| source.id == input } unless input.zero?




    end
    create
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
