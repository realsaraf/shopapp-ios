//
//  CartViewModel.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 11/8/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift
import ShopApp_Gateway

class CartViewModel: BaseViewModel {
    private let cartProductsUseCase: CartProductsUseCase
    private let deleteCartProductUseCase: DeleteCartProductUseCase
    private let changeCartProductUseCase: ChangeCartProductUseCase
    
    var data = Variable<[CartProduct]>([])

    init(cartProductsUseCase: CartProductsUseCase, deleteCartProductUseCase: DeleteCartProductUseCase, changeCartProductUseCase: ChangeCartProductUseCase) {
        self.cartProductsUseCase = cartProductsUseCase
        self.deleteCartProductUseCase = deleteCartProductUseCase
        self.changeCartProductUseCase = changeCartProductUseCase
    }
    
    func loadData(showLoading: Bool = true) {
        if showLoading {
            state.onNext(ViewState.make.loading())
        }
        cartProductsUseCase.getCartProducts { [weak self] (cartProducts, error) in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                strongSelf.state.onNext(.error(error: error))
            } else if let cartProducts = cartProducts {
                strongSelf.data.value = cartProducts
                cartProducts.isEmpty ? strongSelf.state.onNext(.empty) : strongSelf.state.onNext(.content)
            }
        }
    }
    
    func removeCardProduct(at index: Int) {
        state.onNext(ViewState.make.loading(showHud: false))

        let cartProduct = data.value[index]
        deleteCartProductUseCase.deleteCartProduct(cartItemId: cartProduct.id) { [weak self] (_, error) in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                strongSelf.state.onNext(.error(error: error))
            } else {
                strongSelf.removeFromData(with: cartProduct)
                strongSelf.data.value.isEmpty ? strongSelf.state.onNext(.empty) : strongSelf.state.onNext(.content)
            }
        }
    }
    
    func update(cartProduct: CartProduct, quantity: Int) {
        state.onNext(ViewState.make.loading(showHud: false))

        changeCartProductUseCase.changeCartProductQuantity(cartItemId: cartProduct.id, quantity: quantity) { [weak self] (_, error) in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                strongSelf.state.onNext(.error(error: error))
            } else {
                strongSelf.loadData(showLoading: false)
            }
        }
    }
    
    func calculateTotalPrice() -> Float {
        let allPrices = data.value.map({ Float($0.quantity) * NSDecimalNumber(decimal: $0.productVariant?.price ?? Decimal()).floatValue })
        return allPrices.reduce(0, +)
    }
    
    private func removeFromData(with item: CartProduct) {
        guard let index = data.value.index(where: { $0.id == item.id }) else {
            return
        }
        data.value.remove(at: index)
    }

    // MARK: - BaseViewModel

    override func tryAgain() {
        loadData()
    }
}
