defmodule EsmScraperTest do
  use ExUnit.Case
  doctest EsmScraper

  test "parser function should return a list with classifieds" do
    dom = File.read!("clasificados_apartamentos.html")
    list_classifieds = EsmScraper.parser dom
    assert list_classifieds |> is_list
  end
end
