require_relative 'test_helper'

class FeetTestUtils < Minitest::Test
  include Rack::Test::Methods

  def entry
    path = 'misc/1.json'

    base = File.dirname(__FILE__)

    File.join(base, path)
  end

  def test_init
    file = Feet::Model::FileModel.new(entry)

    assert file.instance_of?(Feet::Model::FileModel)
  end

  def test_reader
    file = Feet::Model::FileModel.new(entry)

    assert file['Marco'] == 'Polo'
  end

  def test_setter
    file = Feet::Model::FileModel.new(entry)

    file['Andrew'] = 'Polo'

    assert file['Andrew'] == 'Polo'
  end
end