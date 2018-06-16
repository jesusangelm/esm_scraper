defmodule EsmScraper do
  @moduledoc """
  Documentation for EsmScraper.
  """

  def parser(dom) do
    classifieds_dom = Floki.find(dom, ".classified")
    Enum.map classifieds_dom, fn(c) -> c |> Floki.DeepText.get |> String.replace("\n", "") end
  end

  def html_requester do
    url = "http://www.elsoldemargarita.com.ve/clasificados/index/fsection:1"
    HTTPoison.get! url
  end

  def get_classifieds do
    dom = html_requester()
    dom.body |> parser()
  end
end
