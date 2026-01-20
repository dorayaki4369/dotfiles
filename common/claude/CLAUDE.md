# 個人設定

以下はプログラミング言語の種類やアーキテクチャの違いに関係なく、全てのタスク全般において守らなければならない指標やルールをまとめた汎用的なガイドラインです。

## 開発方針

### 不明点は確認する

開発方針、設計判断、ライブラリの使い方などで不明な点がある場合は、推測で進めずに以下の方法で解決する。

- **ユーザーに確認する**: 要件や設計意図など、コードベースから判断できない事項はユーザーに質問する。
- **Context7で調べる**: ライブラリやフレームワークの使い方やエラー発生時は、Context7を使って最新のドキュメントやコード例を参照する。

### 実装はテストする

ユニットテストやインテグレーションテストは必ず書き、実装が正しいかを継続的に検証する。

### コードをフォーマットする

prettierやPHP-CS-FixerなどのFormatterが使える状態であれば、作業終了後にフォーマットして整える。

## コードスタイル

### 値は不変なものとして扱う

一度代入した値は変更しない。関数の引数も不変として扱い、変更が必要な場合は新しい値を返す。状態の変化を追跡する認知負荷を減らし、バグの発生を防ぐ。

```typescript
// Good
const items = [...existingItems, newItem];

// Bad
let items = existingItems;
items.push(newItem);
```

```typescript
// Good: 引数を変更せず新しいオブジェクトを返す
function updateUser(user: User, name: string): User {
  return { ...user, name };
}

// Bad: 引数を直接変更する
function updateUser(user: User, name: string): void {
  user.name = name;
}
```

### 副作用を最小限に抑え、関数は予測可能な振る舞いを持たせる

同じ入力に対して常に同じ出力を返す。外部状態への依存や変更を避け、テストしやすく理解しやすいコードにする。

```typescript
// Good
function calculateTotal(items: Item[]): number {
  return items.reduce((sum, item) => sum + item.price, 0);
}

// Bad
let total = 0;
function addToTotal(item: Item): void {
  total += item.price;
}
```

### 命名は意図を明確に伝えるものにする

コードを読む人が「なぜ」を理解できる名前をつける。略語や曖昧な名前を避け、処理の目的を明確にする。

```typescript
// Good
async function fetchActiveUsersByLastLoginDate(since: Date): Promise<User[]> { ... }

// Bad
async function getUsers(d: Date): Promise<User[]> { ... }
```

### DRY原則に従い重複を排除する

同じロジックを複数箇所に書かない。重複はバグの温床となり、変更時に修正漏れが発生する。共通処理は関数やモジュールに抽出し、単一の情報源を維持する。

```typescript
// Good: 共通ロジックを抽出
function validateRequired(value: string, fieldName: string): string | null {
  return value.trim() === '' ? `${fieldName}は必須です` : null;
}

function validateUserForm(form: UserForm): string[] {
  return [
    validateRequired(form.name, '名前'),
    validateRequired(form.email, 'メールアドレス'),
  ].filter((error): error is string => error !== null);
}

// Bad: 同じバリデーションロジックが重複
function validateUserForm(form: UserForm): string[] {
  const errors: string[] = [];
  if (form.name.trim() === '') {
    errors.push('名前は必須です');
  }
  if (form.email.trim() === '') {
    errors.push('メールアドレスは必須です');
  }
  return errors;
}
```

### 関数は常に簡潔に保つ

各関数は単一の責務を持ち、短く保つ。複雑な処理は小さな関数に分割し、トップレベルの関数は手順書のように読めるようにする。

#### 分岐処理はswitch-caseと個別関数で分離する

処理が一つのパラメータによって分かれる場合、switch-caseで振り分け、個別処理は専用の関数に切り出す。

```typescript
// Good: switch-caseは振り分けのみ、個別処理は別関数
function handleEvent(event: AppEvent): void {
  switch (event.type) {
    case 'user_created':
      return handleUserCreated(event);
    case 'user_deleted':
      return handleUserDeleted(event);
    case 'user_updated':
      return handleUserUpdated(event);
  }
}

function handleUserCreated(event: UserCreatedEvent): void {
  // ユーザー作成時の処理
}

function handleUserDeleted(event: UserDeletedEvent): void {
  // ユーザー削除時の処理
}

// Bad: switch-case内に処理を直接書く
function handleEvent(event: AppEvent): void {
  switch (event.type) {
    case 'user_created':
      // 長い処理...
      break;
    case 'user_deleted':
      // 長い処理...
      break;
  }
}
```

#### 複雑な処理は手順書のように構成する

トップレベルの関数はサブ関数を順に呼び出すだけにし、処理の流れを一目で把握できるようにする。

```typescript
// Good: トップレベル関数が手順書のように読める
async function processOrder(order: Order): Promise<ProcessedOrder> {
  const validatedOrder = validateOrder(order);
  const pricedOrder = calculatePrices(validatedOrder);
  const inventoryResult = await reserveInventory(pricedOrder);
  const paymentResult = await processPayment(pricedOrder);
  return createProcessedOrder(pricedOrder, inventoryResult, paymentResult);
}

// Bad: すべての処理が一つの関数に詰め込まれている
async function processOrder(order: Order): Promise<ProcessedOrder> {
  // バリデーション処理（20行）
  // 価格計算処理（30行）
  // 在庫予約処理（25行）
  // 支払い処理（40行）
  // 結果作成処理（15行）
}
```

#### 長いtry-catch文は分離する

try-catch文の内容が複雑な場合、try-catchのエラーハンドリング処理と実際の処理の部分を分離させる。

```typescript
// Good: 実際の処理を別関数に切り出し、try-catchはエラーハンドリングのみ
export async function saveUserData(user: User): Promise<Result<User>> {
  try {
    return { success: true, data: await performSaveUserData(user) };
  } catch (error) {
    logger.error('Failed to save user data', { userId: user.id, error });
    return { success: false, error: 'ユーザーデータの保存に失敗しました' };
  }
}

async function performSaveUserData(user: User): Promise<User> {
  const validatedUser = validateUserData(user);
  const normalizedUser = normalizeUserData(validatedUser);
  const savedUser = await userRepository.save(normalizedUser);
  await notificationService.sendWelcomeEmail(savedUser);
  return savedUser;
}

// Bad: try-catch内に長い処理が詰め込まれている
export async function saveUserData(user: User): Promise<Result<User>> {
  try {
    // バリデーション処理（10行）
    // 正規化処理（15行）
    // DB保存処理（10行）
    // 通知処理（10行）
    return { success: true, data: savedUser };
  } catch (error) {
    logger.error('Failed to save user data', { userId: user.id, error });
    return { success: false, error: 'ユーザーデータの保存に失敗しました' };
  }
}
```

### 型安全性を意識する

ジェネリクスやリテラル型を活用し、抽象度を高めつつコンパイル時にエラーを検出できるコードを書く。型システムのない言語ではコメントで型情報を明示する。

#### ジェネリクスで再利用性と型安全性を両立する

```typescript
// Good: ジェネリクスで型安全かつ汎用的
function findById<T extends { id: string }>(items: T[], id: string): T | undefined {
  return items.find((item) => item.id === id);
}

const user = findById(users, '123'); // 型: User | undefined
const product = findById(products, '456'); // 型: Product | undefined

// Bad: any型で型安全性を失う
function findById(items: any[], id: string): any {
  return items.find((item) => item.id === id);
}
```

#### リテラル型とユニオン型で値を制約する

```typescript
// Good: リテラル型で許可される値を限定
type Status = 'pending' | 'approved' | 'rejected';
type HttpMethod = 'GET' | 'POST' | 'PUT' | 'DELETE';

function updateStatus(id: string, status: Status): void { ... }
updateStatus('123', 'approved'); // OK
updateStatus('123', 'invalid'); // コンパイルエラー

// Bad: stringで任意の値を許可
function updateStatus(id: string, status: string): void { ... }
```

#### ブランド型でプリミティブ値を区別する

同じプリミティブ型でも意味が異なる値（ID、電話番号、メールアドレスなど）は、Type Branding（Tagged Type）で型レベルで区別する。これにより、引数の順序間違いや異なる種類のIDの混同をコンパイル時に検出できる。

```typescript
// Good: ブランド型で異なる意味の値を区別
type Brand<T, B extends string> = T & { __brand: B };

type UserId = Brand<string, 'UserId'>;
type ProductId = Brand<string, 'ProductId'>;
type Email = Brand<string, 'Email'>;

function createUserId(id: string): UserId {
  return id as UserId;
}

function getUser(userId: UserId): User { ... }
function getProduct(productId: ProductId): Product { ... }

const userId = createUserId('user-123');
const productId = createProductId('product-456');

getUser(userId); // OK
getUser(productId); // コンパイルエラー: ProductIdはUserIdに代入できない

// Bad: 素のstring型で区別できない
function getUser(userId: string): User { ... }
function getProduct(productId: string): Product { ... }

getUser(productId); // 実行時まで誤りに気づけない
```

#### 型システムのない言語ではコメントで型を明示する

```php
// Good: PHPDocでジェネリクスを使って型情報を明示
/**
 * 指定されたIDを持つアイテムを検索する
 *
 * @template T of array{id: string}
 * @param T[] $items 検索対象のアイテムリスト
 * @param string $id 検索するID
 * @return T|null 見つかったアイテム、見つからない場合はnull
 */
function findById(array $items, string $id): ?array
{
    foreach ($items as $item) {
        if ($item['id'] === $id) {
            return $item;
        }
    }
    return null;
}
```

## 関数の並び順をわかりやすくする

関数の並び順は公開関数/メソッドを上に、プライベート関数/メソッドを下になるように並べる。
また、単純な関数や他の関数から呼び出される関数は下になるように並べる。

## ドキュメントライティング

Markdownドキュメントを書く際は、以下のルールに従うこと。

## Lintルールを守る

[markdownlint](https://github.com/DavidAnson/markdownlint)のルールに従い、一貫性のあるMarkdownを書く。

### Mermaidを使う

文章に図を挿入したい場合は、[Mermaid](https://mermaid.js.org/)を使用する。
