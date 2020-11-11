module SaleBookSupport
  def sale_book(book, sale)
    expect(page).to have_content('書斎へ行く')
    visit user_path(book.user)
    expect(page).to have_content('売る')
    click_on('売る')
    visit new_sale_path(id: book.id)
    find('.select-box1').click
    select '新品', from: 'item-sales-status'
    find('.select-box2').click
    select '着払い(購入者負担)', from: 'item-shipping-fee-status'
    fill_in 'sale[price]', with: sale.price
    expect { click_on('出品する') }.to change { Sale.count }.by(1)
    expect(current_path).to eq "/users/#{book.user.id}"
    expect(page).to have_content('出品中')
  end
end
