let
  Source = Lakehouse.Contents([]),
  #"Navigation 1" = Source{[workspaceId = "dbaacc33-6491-4fbb-bee0-e4bc43e61b2f"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[lakehouseId = "c870bd78-8903-42a1-a20e-f0082643315b"]}[Data],
  #"Navigation 3" = #"Navigation 2"{[Id = "Files", ItemKind = "Folder"]}[Data],
  #"Navigation 4" = #"Navigation 3"{[Name = "raw"]}[Content],
  #"Navigation 5" = #"Navigation 4"{[Name = "cases_deaths.csv"]}[Content],
  #"Imported CSV" = Csv.Document(#"Navigation 5", [Delimiter = ",", Columns = 9, Encoding = 65001, QuoteStyle = QuoteStyle.None]),
  #"Promoted headers" = Table.PromoteHeaders(#"Imported CSV", [PromoteAllScalars = true]),
  #"Changed column type" = Table.TransformColumnTypes(#"Promoted headers", {{"country", type text}, {"country_code", type text}, {"continent", type text}, {"population", Int64.Type}, {"indicator", type text}, {"daily_count", Int64.Type}, {"date", type date}, {"rate_14_day", type number}, {"source", type text}}),
  #"Filtered rows" = Table.SelectRows(#"Changed column type", each ([continent] = "Europe")),
  #"Choose columns" = Table.SelectColumns(#"Filtered rows", {"country", "country_code", "population", "indicator", "daily_count", "date"}),
  #"Renamed columns" = Table.RenameColumns(#"Choose columns", {{"date", "reported_date"}})
in
  #"Renamed columns"
