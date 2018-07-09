defmodule EsmScraper do
  @moduledoc """
  Documentation for EsmScraper.
  """
  @url_apartment_rent "http://www.elsoldemargarita.com.ve/clasificados/index/fsection:1"
  @url_house_rent "http://www.elsoldemargarita.com.ve/clasificados/index/fsection:4"

  def parser(dom) do
    dom
    |> Floki.find(".classified")
    |> Enum.map(&(&1 |> Floki.text |> String.replace("\n", "")))
  end

  def page_ammount_inspector(dom) do
    [_,_,_, head | _] = dom |> Floki.find("hr+ p") |> Floki.text() |> String.split(" ")

    head
    |> String.replace(",", "")
    |> String.to_integer()
  end

  def url_generator(type, pages) do
    url_base = url_selector(type)

    Enum.reduce(pages, [], fn(page, acc) ->
      acc ++ url_base <> "/page:#{page}"
    end)
  end

  def url_selector(type) do
    case type do
      :apartment_rent -> @url_apartment_rent
      :house_rent -> @url_house_rent
      _ -> nil
    end
  end

  def html_requester(url), do: HTTPoison.get!(url).body

  def get_classifieds(type) do
    dom_base = type |> url_selector() |> html_requester()
    pages = page_ammount_inspector(dom_base)
    urls = url_generator(type, pages)

    urls
    |> Enum.map(&(&1 |> html_requester() |> parser()))
    |> List.flatten()
  end
end
