TEST_DB = SQLite3::Database.new 'test.db'

class MyTestTable < Feet::Model::SQLiteModel
  def self.init_table
    drop_table

    TEST_DB.execute <<~SQL
      CREATE TABLE IF NOT EXISTS my_test_table (
        id INTEGER PRIMARY KEY,
        posted INTEGER,
        title VARCHAR(30),
        body VARCHAR(32000)
      );
    SQL
  end

  def self.drop_table
    TEST_DB.execute <<~SQL
      DROP TABLE IF EXISTS my_test_table;
    SQL
  end
end
