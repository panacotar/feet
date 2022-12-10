require_relative 'test_helper'

class FeetTestUtils < Minitest::Test
  include Rack::Test::Methods

  def entry
    path = 'misc/1.json'

    base = File.dirname(__FILE__)

    File.join(base, path)
  end

  def file_init
    Feet::Model::FileModel.new(entry)
  end

  def test_init
    file = file_init

    assert file.instance_of?(Feet::Model::FileModel)
  end

  def test_reader
    file = file_init

    assert file['Marco'] == 'Polo'
  end

  def test_setter
    file = file_init

    file['Andrew'] = 'Polo'

    assert file['Andrew'] == 'Polo'
  end
end
