//
//  NewsViewModel.swift
//  TestProject
//
//  Created by Nana Jimsheleishvili on 23.11.23.
//

import Foundation

protocol NewsViewModelDelegate {
    func newsFetched(_ news: [News])
    func showError(_ error: Error)
}

protocol NewsViewModel {
    var delegate: NewsViewModelDelegate? { get set }
    func viewDidLoad()
}

final class DefaultNewsViewModel: NewsViewModel {
    
    // MARK: - Properties
    private let newsAPI = "https://newsapi.org/v2/everything?q=tesla&from=2023-11-11&sortBy=publishedAt&apiKey=65dae9fca8a44369b2297014f1e710ce"  //Too much results, changed year and changed API because of too much request during 24 hour
    private var newsList = [News]()

    var delegate: NewsViewModelDelegate?

    // MARK: - Public Methods
    func viewDidLoad() {
        fetchNews()
    }
    
    // MARK: - Private Methods
    private func fetchNews() {
        NetworkManager.shared.get(url: newsAPI) { [weak self] (result: Result<Article, Error>) in
            switch result {
            case .success(let article):
                self?.newsList = article.articles // if we use .append we will give whole fetched data as 1 element of array
                self?.delegate?.newsFetched(self?.newsList ?? []) //added self?. and needed unwrap
            case .failure(let error):
                self?.delegate?.showError(error)
            }
        }
    }
}

