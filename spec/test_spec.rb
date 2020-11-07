describe 'Test', type: :routing do
  it 'Test' do
    expect(true).to be true
  end

  it { should belong_to(:category).class_name('MenuCategory') }

  it '' do
            should route(:get, '/posts').
              to(controller: :posts, action: :index)
          end
end
