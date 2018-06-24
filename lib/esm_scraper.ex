defmodule EsmScraper do
  @moduledoc """
  Documentation for EsmScraper.
  """
  @url_apartment_rent "http://www.elsoldemargarita.com.ve/clasificados/index/fsection:1"
  @url_house_rent "http://www.elsoldemargarita.com.ve/clasificados/index/fsection:4"

  def parser(dom) do
    classifieds_dom = Floki.find(dom, ".classified")
    Enum.map classifieds_dom, &(&1 |> Floki.DeepText.get |> String.replace("\n", ""))
  end

  def page_ammount_inspector(dom) do
    [_,_,_, head | _] = dom |> Floki.find("hr+ p") |> Floki.text |> String.split(" ")
    head |> String.replace(",", "") |> String.to_integer
  end

  def url_generator(type, pages) do
    url_base = url_selector(type)
    list = []
    for n <- 1..pages do
      list = list ++ url_base <> "/page:#{n}"
    end
  end

  def url_selector(type) do
    case type do
      :apartment_rent -> @url_apartment_rent
      :house_rent -> @url_house_rent
      _ -> nil
    end
  end

  def html_requester(url) do
    dom = url |> HTTPoison.get!
    dom.body
  end

  def get_classifieds(type) do
    dom_base = url_selector(type) |> html_requester()
    pages = page_ammount_inspector(dom_base)
    urls = url_generator(type, pages)

    classifieds = Enum.map urls, &(&1 |> html_requester |> parser())
    classifieds |> List.flatten
  end
end
