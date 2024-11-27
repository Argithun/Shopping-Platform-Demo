# 设计文档

## 模块设计

### 登录注册模块
使用 devise 插件进行登录注册模块的构建：
```
rails generate devise User
```
为自动生成的 User 类添加电话号码和角色属性
```ruby
class AddPhoneAndRoleToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :phone_number, :string
    add_column :users, :role, :string
  end
end
```
这样使得用户在登录时能选择注册成为购买者或管理员。

### 商品清单模块
新建商品表：
```ruby
class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.decimal :price
      t.integer :sales
      t.string :image_path
      t.string :product_type
      t.string :color

      t.timestamps
    end
  end
end
```
在商品类的控制器中，实现添加、删除、展示列表、查看详情的方法。

### 收藏栏模块
新建收藏条目表：
```ruby
class CreateFavorites < ActiveRecord::Migration[7.1]
  def change
    create_table :favorites do |t|
      t.string :name
      t.text :description
      t.decimal :price
      t.integer :sales_count
      t.string :image_url
      t.string :product_type
      t.string :color
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
```
该模块仅限身份为购买者的用户访问；
在控制器中添加新建、删除、查看详情和展示列表方法；
在商品详情页面中添加按钮 Favor this Product 触发一个新建收藏条目动作；
考虑到用户可能使用收藏栏来记录自己的喜好和倾向，故没有对 product 添加外键约束，使商品删除后还是可以在收藏栏查看浏览记录。

### 购物车模块
新建购物车条目表
```ruby
class CreateCartItems < ActiveRecord::Migration[7.1]
  def change
    create_table :cart_items do |t|
      t.references :user, foreign_key: true
      t.references :product, foreign_key: true
      t.string :user_email
      t.string :product_name
      t.integer :quantity
      t.datetime :added_at
      t.timestamps
    end
  end
end

class AddCostToCartItems < ActiveRecord::Migration[7.1]
  def change
    add_column :cart_items, :cost, :decimal, precision: 10, scale: 2
  end
end
```
该模块仅限身份为购买者的用户访问；
在控制器中添加新建、删除、查看详情和展示列表方法；
在商品详情页面中添加按钮 Add to My Cart 和一个个数输入栏触发一个新建购物车项的动作；
该表的 product 采用外键约束，且级联删除。

### 订单模块
新建订单条目表：
```ruby
class CreateOrderItems < ActiveRecord::Migration[7.1]
  def change
    create_table :order_items do |t|
      t.integer :product_id
      t.integer :user_id
      t.string :receiver
      t.string :shipping_address
      t.string :phone_number
      t.string :postal_code
      t.integer :quantity
      t.decimal :total_amount
      t.string :order_status

      t.timestamps
    end
  end
end
```
该模块下，购买者只能看到自己的订单，而管理员可以看到所有订单；
在控制器中添加新建、删除、查看详情和展示列表方法；
在购物车条目列表视图中添加按钮 Order 通过购物车信息生成订单；
该表的 order_status 属性指示了订单状态：
1. To be paid
2. To be sent
3. To be received
4. Completed
5. Cancelled
6. Rejected

购买者可以通过 pay 动作将商品从状态 1 转换到状态 2
管理员可以通过 send 动作将商品从状态 2 转换到状态 3
购买者可以通过 receive 动作将商品从状态 3 转换到状态 4
在状态1, 2, 3购买者可以通过 cancel 动作将状态转换为状态 5
在状态 2，管理员可以通过 reject 动作将状态转换为状态 6
仅有状态4, 5, 6下的条目可以由 delete 动作删除。
考虑到交易的完整性，订单条目模块也没有进行 product 的外键约束。

-----------------------------------------------

## 使用方式

### 购买者
* 注册身份选择 buyer (默认)
* 进入主界面（商品列表）
  * 可点击 View 查看商品详情
    * 可点击 Favor this Product 将商品添加到收藏
    * 可输入数字到 Quantity，点击 Add to My Cart 将商品添加到购物车（总金额会）同步计算
  * 可点击 My Favorites 查看收藏栏
    * 可点击 View 查看收藏项目的具体属性内容
  * 可点击 My Order 查看用户本人的订单
    * 可选择订单条目后的 Action 中的按钮对订单进行操作

### 管理员
* 注册身份选择 admin
* 进入主界面（商品列表）
  * 可点击 View 查看商品详情
  * 可点击 Edit 修改商品属性
  * 可点击 Delete 删除商品条目
  * 可点击 Add Product 新建商品条目
    * 在新建页面输入相应的商品信息，注意图片的 URL 可以为空，但若填写则一定要合法，否则将无法创建
  * 可点击 All Orders 查看所有待处理的订单，可以选择 Send 或 Reject，处理完毕的订单将自动消除 