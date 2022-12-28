require 'sqlite3'
require_relative 'test_helper'
require_relative './misc/my_test_table'

# Run to initialize the DB + my_test_table
MyTestTable.init_table

class FeetTestSQLiteModel < Minitest::Test
  def create_entry
    item = { 'posted' => 0, 'title' => 'my test title', 'body' => 'Once upon a time...' }
    MyTestTable.create item
  end

  def test_create
    item = { 'posted' => 1, 'title' => 'my test title', 'body' => 'Once upon a time...', 'id' => 7 }
    row = MyTestTable.create item

    assert row.instance_of?(MyTestTable)
    refute_equal row.id, 7, 'It should ignore the argument id'
    assert_equal 'my test title', row['title'], 'It should keep the title'
  end

  def test_find
    row = MyTestTable.find 1

    if row.nil?
      create_entry
      row = MyTestTable.find 1
    end

    assert !row.nil?, 'It should find a row'
  end

  def test_schema
    schema = MyTestTable.schema

    keys = %w[id posted title body]

    assert_equal schema.keys, keys, 'Schema should return all the keys'
  end

  def test_table_name
    name = MyTestTable.table

    assert_equal 'my_test_table', name, 'It should return the right table name'
  end

  def test_getter_method
    row = create_entry

    assert_equal Integer, row.posted&.class, 'It should access a field with the method notation'
  end

  def test_setter_method
    row = create_entry
    row.posted = 1

    assert_equal 1, row.posted, 'It should set a field using the method notation'
  end
end
