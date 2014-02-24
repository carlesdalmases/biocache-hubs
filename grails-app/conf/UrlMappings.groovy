class UrlMappings {

	static mappings = {
        "/$controller/$action?/$id?(.$format)?"{
            constraints {
                // apply constraints here
            }
        }
        "/occurrences/search"(controller: 'occurrence', action: 'search')
        "/occurrence/search"(controller: 'occurrence', action: 'search')
        "/occurrence/index"(controller: 'occurrence', action: 'index')
        "/occurrences/$id"(controller: 'occurrence', action: 'show')
        "/occurrence/$id"(controller: 'occurrence', action: 'show')
        "/assertions/$id"(controller: 'occurrence', action: 'assertions')
        "/"(view:"/index")
        "500"(view:'/error')
        "404"(view:'/error')
	}
}
