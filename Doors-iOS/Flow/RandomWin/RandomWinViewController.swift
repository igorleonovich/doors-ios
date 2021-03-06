//
//  Copyright (c) 2017. Uber Technologies
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import RIBs_Swift_SDK
import RxSwift
import RxCocoa
import SnapKit

protocol RandomWinPresentableListener: AnyObject {
    func determineWinner()
}

final class RandomWinViewController: ViewController, RandomWinPresentable, RandomWinViewControllable {

    weak var listener: RandomWinPresentableListener?

    init(player1Name: String,
         player2Name: String) {
        self.player1Name = player1Name
        self.player2Name = player2Name
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Method is not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.cyan
        buildGoButton()
    }

    // MARK: - RandomWinPresentable

    func announce(winner: PlayerType, withCompletionHandler handler: @escaping () -> ()) {
        let winnerString: String = {
            switch winner {
            case .player1:
                return "\(player1Name) Won!"
            case .player2:
                return "\(player2Name) Won!"
            }
        }()
        #if os(iOS) || os(watchOS) || os(tvOS)
            let alert = AlertController(title: winnerString, message: nil, preferredStyle: .alert)
            let closeAction = AlertAction(title: "That was random...", style: AlertAction.Style.default) { _ in
                handler()
            }
            alert.addAction(closeAction)
            present(alert, animated: true, completion: nil)
        #endif
    }

    // MARK: - Private

    private let player1Name: String
    private let player2Name: String

    private func buildGoButton() {
        let button = Button()
        button.setTitle("Magic", for: .normal)
        button.backgroundColor = Color.purple
        button.setTitleColor(Color.white, for: .normal)
        view.addSubview(button)
        button.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.center.equalTo(self.view.snp.center)
            maker.leading.trailing.equalTo(self.view).inset(20)
            maker.height.equalTo(100)
        }

        button.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.listener?.determineWinner()
            })
            .disposed(by: disposeBag)
    }

    private let disposeBag = DisposeBag()
}
