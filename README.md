# データベース設計

## categoriesテーブル

| Column             | Type       | Options                        |
| ------------------ | ---------- | ------------------------------ |
| name               | string     | null: false, unique: true      |

- has_many: ideas

## ideasテーブル

| Column             | Type       | Options                        |
| ------------------ | ---------- | ------------------------------ |
| body               | text       | null: false                    |
| category           | references | null: false, foreign_key: true |

- belongs_to: category