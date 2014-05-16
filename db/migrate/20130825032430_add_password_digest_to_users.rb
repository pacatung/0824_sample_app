class AddPasswordDigestToUsers < ActiveRecord::Migration
  def change

  	#======0825
  	add_column :users, :password_digest, :string

  end
end
