# API — Coffee Shop

Contrato HTTP consumido pelo app. Hoje ele é atendido pelo **servidor mockado**
(`packages/core/lib/src/api/mock_api_client.dart`), que responde exatamente com
os caminhos, códigos e corpos descritos aqui. Para usar um backend real, basta
implementar `ApiClient` com HTTP e trocá-lo em `lib/app/app_dependencies.dart`.

- **Base URL (real):** `https://api.coffeeshop.dev/v1` *(exemplo)*
- **Formato:** JSON (`Content-Type: application/json`)
- **Autenticação:** `Authorization: Bearer <token>` em todas as rotas, exceto `POST /auth/login`
- **Moeda:** valores em dólar (`number`, 2 casas), como no Figma

## Sumário

| Método | Rota | Autenticada | Usada pela cena |
|---|---|---|---|
| POST | `/auth/login` | não | Login |
| POST | `/auth/logout` | sim | Home (sair) |
| GET | `/me` | sim | Launch, Home |
| GET | `/categories` | sim | Home |
| GET | `/products` | sim | Home |
| GET | `/products/{id}` | sim | Product Detail |
| GET | `/promotions` | sim | Home |
| POST | `/orders/quote` | sim | Order |
| POST | `/orders` | sim | Order |
| GET | `/orders/{id}` | sim | Order Tracking |

## Erros

Todo erro segue o mesmo envelope:

```json
{
  "error": {
    "code": "invalid_credentials",
    "message": "E-mail ou senha incorretos."
  }
}
```

| HTTP | `code` | Quando |
|---|---|---|
| 400 | `validation_error` | Campos obrigatórios ausentes |
| 400 | `empty_cart` | Pedido/cotação sem itens |
| 401 | `invalid_credentials` | Login com e-mail/senha errados |
| 401 | `unauthorized` | Token ausente, inválido ou após logout |
| 404 | `product_not_found` | Produto inexistente |
| 404 | `order_not_found` | Pedido inexistente ou de outro usuário |
| 404 | `not_found` | Rota inexistente |
| 422 | `invalid_item` | `productId` inexistente ou `quantity <= 0` |
| 422 | `invalid_size` | Tamanho não oferecido pelo produto |
| 422 | `address_required` | Entrega sem endereço |
| 0 | `network_error` | Falha de rede (gerado no cliente) |

No app, toda resposta fora de 2xx vira `ApiException(statusCode, code, message)`.
Um `401` em cenas autenticadas leva o usuário de volta ao Login.

---

## Autenticação

### `POST /auth/login`

**Request**

```json
{
  "email": "ana@coffee.dev",
  "password": "123456"
}
```

**Response `200 OK`**

```json
{
  "token": "tok_u_1_1",
  "user": {
    "id": "u_1",
    "name": "Ana Souza",
    "email": "ana@coffee.dev",
    "avatarUrl": null,
    "memberSince": "2026-03-14T10:00:00Z",
    "address": {
      "title": "Jl. Kpg Sutoyo",
      "line": "Kpg. Sutoyo No. 620, Bilzen, Tanjungbalai."
    }
  }
}
```

**Erros:** `400 validation_error`, `401 invalid_credentials`.

> Conta de demonstração do mock: `ana@coffee.dev` / `123456`.

### `POST /auth/logout`

**Request:** sem corpo.
**Response `204 No Content`:** sem corpo. O token deixa de valer.

### `GET /me`

**Response `200 OK`:** o objeto `user` (mesmo formato do login).
**Erros:** `401 unauthorized`.

---

## Catálogo

### `GET /categories`

**Response `200 OK`**

```json
{
  "items": [
    { "id": "machiato", "name": "Machiato" },
    { "id": "latte", "name": "Latte" },
    { "id": "americano", "name": "Americano" }
  ]
}
```

> A aba "Todos" é montada pelo app (sem `categoryId`).

### `GET /products`

**Query params (opcionais)**

| Parâmetro | Tipo | Descrição |
|---|---|---|
| `categoryId` | string | Filtra pela categoria |
| `q` | string | Busca no nome e subtítulo (sem diferenciar maiúsculas) |

Exemplo: `GET /products?categoryId=latte&q=mocha`

**Response `200 OK`**

```json
{
  "items": [
    {
      "id": "p_caffe_mocha",
      "name": "Caffe Mocha",
      "subtitle": "Deep Foam",
      "description": "A cappuccino is an approximately 150 ml (5 oz) beverage...",
      "categoryId": "latte",
      "rating": 4.8,
      "reviewCount": 230,
      "imageUrl": "assets/images/coffee_1.png",
      "sizes": [
        { "code": "S", "price": 4.03 },
        { "code": "M", "price": 4.53 },
        { "code": "L", "price": 5.53 }
      ],
      "features": ["fast_delivery", "quality_bean", "extra_milk"],
      "isAvailable": true
    }
  ]
}
```

Campos de `product`:

| Campo | Tipo | Observação |
|---|---|---|
| `id` | string | |
| `name`, `subtitle`, `description` | string | |
| `categoryId` | string | |
| `rating` | number | 0–5 |
| `reviewCount` | integer | |
| `imageUrl` | string \| null | URL ou caminho de asset |
| `sizes` | `{code, price}[]` | `code` ∈ `S`, `M`, `L`; o card mostra o preço de `M` |
| `features` | string[] | `fast_delivery`, `quality_bean`, `extra_milk` |
| `isAvailable` | boolean | `false` desabilita o botão "+" e o "Comprar agora" |

### `GET /products/{id}`

**Response `200 OK`:** um `product`.
**Erros:** `404 product_not_found`.

### `GET /promotions`

**Response `200 OK`**

```json
{
  "items": [
    {
      "id": "promo_bogo",
      "tag": "Promo",
      "title": "Leve 2, pague 1",
      "imageUrl": "assets/images/banner.png"
    }
  ]
}
```

---

## Pedidos

### `POST /orders/quote`

Calcula os valores do "Resumo do pagamento" **sem** criar o pedido. O app chama
esta rota a cada mudança de quantidade ou de tipo de entrega.

**Request**

```json
{
  "deliveryType": "deliver",
  "items": [
    { "productId": "p_caffe_mocha", "size": "M", "quantity": 1 }
  ]
}
```

| Campo | Tipo | Valores |
|---|---|---|
| `deliveryType` | string | `deliver` \| `pick_up` |
| `items[].productId` | string | |
| `items[].size` | string | `S` \| `M` \| `L` |
| `items[].quantity` | integer | ≥ 1 |

**Response `200 OK`**

```json
{
  "subtotal": 4.53,
  "deliveryFeeOriginal": 2.0,
  "deliveryFee": 1.0,
  "discount": 1.0,
  "discountLabel": "1 desconto aplicado",
  "total": 5.53
}
```

Regras do mock: entrega custa `2.00` com desconto para `1.00`; retirada (`pick_up`) não tem taxa
(`deliveryFee = 0`, `discountLabel = null`). `total = subtotal + deliveryFee`.

**Erros:** `400 empty_cart`, `422 invalid_item`, `422 invalid_size`.

### `POST /orders`

**Request**

```json
{
  "deliveryType": "deliver",
  "paymentMethod": "Dinheiro/Carteira",
  "address": {
    "title": "Jl. Kpg Sutoyo",
    "line": "Kpg. Sutoyo No. 620, Bilzen, Tanjungbalai."
  },
  "items": [
    { "productId": "p_caffe_mocha", "size": "M", "quantity": 1 }
  ]
}
```

`address` é obrigatório quando `deliveryType = deliver`.

**Response `201 Created`**

```json
{
  "id": "ord_1001",
  "userId": "u_1",
  "status": "placed",
  "deliveryType": "deliver",
  "address": {
    "title": "Jl. Kpg Sutoyo",
    "line": "Kpg. Sutoyo No. 620, Bilzen, Tanjungbalai."
  },
  "paymentMethod": "Dinheiro/Carteira",
  "items": [
    { "productId": "p_caffe_mocha", "name": "Caffe Mocha", "size": "M", "quantity": 1, "unitPrice": 4.53 }
  ],
  "summary": {
    "subtotal": 4.53,
    "deliveryFeeOriginal": 2.0,
    "deliveryFee": 1.0,
    "discount": 1.0,
    "discountLabel": "1 desconto aplicado",
    "total": 5.53
  },
  "createdAt": "2026-10-30T23:59:00.000Z",
  "estimatedMinutes": 10,
  "courier": { "name": "Brooklyn Simmons", "phone": "+62 812 0000 0000" }
}
```

`courier` é `null` em pedidos para retirada.

**Erros:** os mesmos da cotação, mais `422 address_required`.

### `GET /orders/{id}`

**Response `200 OK`:** o objeto `order` acima, com `status` e `estimatedMinutes` atualizados.

| `status` | Etapas concluídas (barra de progresso) |
|---|---|
| `placed` | 1 de 4 |
| `preparing` | 2 de 4 |
| `on_the_way` | 3 de 4 |
| `delivered` | 4 de 4 |

> **Simulação do mock:** a 1ª consulta devolve o pedido como criado; cada consulta seguinte
> avança uma etapa (por isso o botão "Atualizar status" faz o pedido andar).

**Erros:** `404 order_not_found`.
