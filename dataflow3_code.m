let
  Source = Lakehouse.Contents(null),
  Navigation = Source{[workspaceId = "dbaacc33-6491-4fbb-bee0-e4bc43e61b2f"]}[Data],
  #"Navigation 1" = Navigation{[lakehouseId = "c870bd78-8903-42a1-a20e-f0082643315b"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[Id = "Files", ItemKind = "Folder"]}[Data],
  #"Navigation 3" = #"Navigation 2"{[Name = "raw"]}[Content],
  #"Navigation 4" = #"Navigation 3"{[Name = "country_lookup.csv"]}[Content],
  #"Imported CSV" = Csv.Document(#"Navigation 4", [Delimiter = ",", Columns = 5, QuoteStyle = QuoteStyle.None]),
  #"Promoted headers" = Table.PromoteHeaders(#"Imported CSV", [PromoteAllScalars = true]),
  #"Changed column type" = Table.TransformColumnTypes(#"Promoted headers", {{"country", type text}, {"country_code_2_digit", type text}, {"country_code_3_digit", type text}, {"continent", type text}, {"population", Int64.Type}})
in
  #"Changed column type"