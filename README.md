# README

# テーブル設計

## users

| Column   | Type   | Options     |
| -------- | ------ | ----------- |
| name     | string | null: false |
| email    | string | null: false |
| password | string | null: false |
| text     | string |             |

### Association
- has_many :books
- has_many :favorites
- has_many :favorite_books, through: :favorites, source: :book
- has_many :lists

## books

| Column | Type       | Options                        |
| ------ | ---------- | ------------------------------ |
| title  | string     | null: false                    |
| author | text       | null: false                    |
| user   | references | null: false, foreign_key: true |

### Association
- belongs_to :user
- has_many   :posts
- has_many   :favorites
- has_many   :book_tag_relations
- has_many   :tags, through: :book_tag_relations

## posts

| Column    | Type       | Options                        |
| --------- | ---------- | ------------------------------ |
| highlight | string     | null: false                    |
| text      | string     | null: false                    |
| book      | references | null: false, foreign_key: true |

### Association
- belongs_to :book

## tags

| Column | Type   | Options                       |
| ------ | ------ | ----------------------------- |
| name   | string | null: false, uniqueness: true |

### Association
- has_many :book_tag_relations
- has_many :books, through: :book_tag_relations

## favorites

| Column | Type       | Options                        |
| ------ | ---------- | ------------------------------ |
| user   | references | null: false, foreign_key: true |
| book   | references | null: false, foreign_key: true |

### Association
- belongs_to :user
- belongs_to :book

## lists

| Column | Type       | Options                        |
| ------ | ---------- | ------------------------------ |
| text   | string     | null: false                    |
| user   | references | null: false, foreign_key: true |

### Association
- belongs_to :user