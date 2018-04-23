# API for ContentStore content

## Credit to Gavin Pickin 
https://github.com/gpickin/contentbox-api

## Installing

`box install git+https://github.com/aliaspooryorik/contentbox-api.git`

## Usage

It's just a snippet... but you should be able to do something like this. `/api/v1/contentstore/search/` and pull up all contentstore items
`/api/v1/contentstore/:slug` 
will return that item from the contentstore by default it returns a tiny struct of info but you might want to do 
`/api/v1/contentstore/:slug?memento=true` 
and it will return everything.
or you can edit the api handler, to choose what you want in the struct by default.

```
if( rc.memento ){
  var itemStruct = item.getMemento();
} else {
  var itemStruct = {
      "title": item.getTitle(),
      "startDate": item.getPublishedDate(),
      "endDate": item.getExpireDate()
  };
  structAppend( itemStruct, item.getCustomFieldsAsStruct() );
}
```
