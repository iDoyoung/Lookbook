import CoreLocation

protocol LocationFetcher {
    var locationFetcherDelegate: LocationFetcherDelegate? { get set }
    var authorizationStatus: CLAuthorizationStatus { get }
    
    func requestWhenInUseAuthorization()
    func startUpdatingLocation()
    func stopUpdatingLocation()
}

protocol LocationFetcherDelegate: AnyObject {
    func locationFetcher(_ fetcher: LocationFetcher, didFailWithError error: Error)
    func locationFetcher(_ fetcher: LocationFetcher, didUpdate locations: [CLLocation])
    func locationManagerDidChangeAuthorization(_ fetcher: LocationFetcher)
}
