alias Keep.Todo

# Some fake todos

todos = %{
  "Programming Books" => [
    "Elixir in Action",
    "Started with Elixir",
    "Elixir Phoenix Web Programming",
    "Distributed Systems"
  ],
  "Crypto Currencies" => ["Bitcoin", "Dogecoin", "Shibcoin", "Ethereum"],
  "Countries" => ["Pakistan", "Turkey", "America", "Iran", "Saudi Arabia"],
  "Wild Animals" => ["Lion", "Tiger", "Giraffe", "Zebra", "Hippo", "Lynx", "Fox"],
  "Random Facts" => [
    "Coding has over 700 languages.",
    "Coding Bugs were NOT named after an actual bug.",
    "Coding will soon be as important as reading.",
    "The first computer virus was a Creeper."
  ]
}

# Create todos

todos
|> Enum.each(fn {k, v} ->
  Todo.create_list_with_items(%{title: k}, v)
end)
