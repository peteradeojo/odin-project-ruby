def love_language(name)
  yield("Ruby #{name}")
  yield('Rails')
end

def transaction_statement(transactions)
  formatted_transactions = []
  transactions.each do |transaction|
    formatted_transactions << yield(transaction)
  end

  p formatted_transactions
end

@transactions = [10, -15, 25, 30, -24, -70, 999]

transaction_statement(@transactions) do |transaction|
  "%0.2f" % transaction
end

def simple_method
  if block_given?
    yield
  else
    puts "No block given"
  end
end

my_lambda = ->(name) {puts "my lambda"}
my_lambda.call 'Bolu'

a_proc = proc {|name, age| puts "#{name} --- age: #{age}"}
a_proc.call