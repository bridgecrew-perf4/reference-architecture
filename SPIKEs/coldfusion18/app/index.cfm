<html>
  <head>
    <title>Example</title>
  </head>
  <body>
    <h1>Hello World!</h1>
    <cfquery name="movies" datasource="example">
      select *
      from Movies
    </cfquery>
    <cfloop query="movies">
      <cfoutput>
        <p>#movies.name#</p>
      </cfoutput>
    </cfloop>
  </body>
</html>
