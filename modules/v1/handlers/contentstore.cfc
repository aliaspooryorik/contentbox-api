/**
* Our main handler
*/
component extends="api.handlers.BaseHandler"{

	property name="cb"	inject="id:cbHelper@cb";
	property name="contentStoreService"	inject="id:contentStoreService@cb";

	/**
	* Search ContentStore Items
	*/
	function search( event, rc, prc ){
		param name="rc.sortOrder" default="publishedDate";
		param name="rc.max" default="0";
		param name="rc.isPublished" default="1";
		param name="rc.slugPrefix" default="";
		param name="rc.memento" default="false";

		prc.parent = cb.contentStoreObject( slug="#rc.slugPrefix#" );
		prc.list = contentStoreService.search(
			parent=prc.parent.getContentID(),
			sortOrder=rc.sortOrder,
			isPublished=rc.isPublished
		);

		prc.returnArray = [];
		for( var item in prc.list.content ){
			if( arrayLen( prc.returnArray ) lte rc.max || rc.max == 0 ){

				if( !item.isExpired() ){
					if( rc.memento == true ){
						var payload = item.getMemento();
					} else {
						var payload = {
							"title": item.getTitle(),
							"slug": item.getSlug(),
							"startDate": item.getPublishedDate(),
							"endDate": item.getExpireDate()
						};
						structAppend( payload, item.getCustomFieldsAsStruct() );
					}

					arrayAppend( prc.returnArray, payload );
				}
			}
		}

		prc.response.setData( prc.returnArray );
	}

	/**
	* get ContentStore item by SLUG
	*/
	function get( event, rc, prc ){
		param name="rc.slug" default="";
		param name="rc.memento" default="false";

		var item = cb.contentStoreObject( slug="#rc.slug#" );

		if( isNull( item ) || !item.isLoaded() ){
			prc.response.setError( true );
			prc.response.addMessage( 'ContentStore item not found' );
		} else {
			if( rc.memento == true ){
				var payload = item.getMemento();
			} else {
				var payload = {
					"title": item.getTitle(),
					"content": item.getcontent(),
					"isContentPublished": item.isContentPublished(),
					"hasActiveContent": item.hasActiveContent(),
					"startDate": item.getPublishedDate(),
					"endDate": item.getExpireDate()
				};
				structAppend( payload, item.getCustomFieldsAsStruct() );
			}

			prc.response.setData( payload );
		}


	}

}
