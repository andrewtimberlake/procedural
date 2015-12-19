# Procedural [![Build Status](https://travis-ci.org/andrewtimberlake/procedural.svg)](https://travis-ci.org/andrewtimberlake/procedural) [![Code Climate](https://codeclimate.com/github/andrewtimberlake/procedural/badges/gpa.svg)](https://codeclimate.com/github/andrewtimberlake/procedural)

Procedural adds the ability to add functions and triggers via ActiveRecord migrations.

Thanks to [Spectacles](https://github.com/liveh2o/spectacles) where I took much inspiration for the groundwork of this gem.

## Installation

```
gem install procedural   #=> or include it in your Gemfile
```

## Example Migration

```ruby
class AddCreatedAtTrigger < ActiveRecord::Migration
  def change
    create_procedure :created_at_trigger, language: 'plpgsql', returns: 'trigger', sql: <<-SQL
              IF (TG_OP = 'UPDATE') THEN
                NEW."created_at" := OLD."created_at";
              ELSIF (TG_OP = 'INSERT') THEN
                NEW."created_at" := CURRENT_TIMESTAMP;
              END IF;
              RETURN NEW;
          SQL

    create_procedure :updated_at_trigger, language: 'plpgsql', returns: 'trigger', sql: <<-SQL
              NEW."updated_at" := CURRENT_TIMESTAMP;
              RETURN NEW;
          SQL

    create_trigger :users, :users_created_at, :created_at_trigger
    create_trigger :users, :users_updated_at, :updated_at_trigger

    create_trigger :posts, :posts_created_at, :created_at_trigger
    create_trigger :posts, :posts_updated_at, :updated_at_trigger
  end
end
```

## License
The MIT License (MIT)

Copyright (c) 2015 Andrew Timberlake

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.