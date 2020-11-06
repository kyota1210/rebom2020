class Status < ActiveHash::Base
  self.data = [
    { id: 0, name: '---' },
    { id: 1, name: '新品' },
    { id: 2, name: 'ほぼ新品' },
    { id: 3, name: '目立った汚れなし' },
    { id: 4, name: 'やや汚れあり' },
    { id: 5, name: '全体的に状態が悪い' }
  ]

  include ActiveHash::Associations
  has_many :sales
end
