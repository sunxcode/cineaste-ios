//
//  SearchMoviesViewController+Webservice.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 03.02.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

extension SearchMoviesViewController {
    func loadMovies(forQuery query: String? = nil, nextPage: Bool = false, handler: @escaping ([Movie]) -> Void) {
        var pageToLoad = 1
        if let page = currentPage,
            nextPage {
            pageToLoad = page + 1
        }

        let resource: Resource<PagedMovieResult>?
        if let query = query, !query.isEmpty {
            resource = Movie.search(withQuery: query, page: pageToLoad)
        } else {
            resource = Movie.latestReleases(page: pageToLoad)
        }

        Webservice.load(resource: resource) { result in
            switch result {
            case .error:
                self.showAlert(withMessage: Alert.loadingDataError)
                handler([])
            case .success(let result):
                self.currentPage = result.page
                self.totalResults = result.totalResults
                handler(result.results)
            }
        }
    }

    func loadDetails(for movie: Movie, completionHandler handler: @escaping (Movie?) -> Void) {
        Webservice.load(resource: movie.get) { result in
            switch result {
            case .error:
                self.showAlert(withMessage: Alert.loadingDataError)
                handler(nil)
            case .success(let detailedMovie):
                detailedMovie.poster = movie.poster
                handler(detailedMovie)
            }
        }
    }
}
