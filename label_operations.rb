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