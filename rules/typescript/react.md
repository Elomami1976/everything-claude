<![CDATA[# React TypeScript Rules

Best practices for building React applications with TypeScript.

## 1. Component Types

**Use function components with proper typing:**

```tsx
// Props interface
interface ButtonProps {
  label: string;
  onClick: () => void;
  variant?: 'primary' | 'secondary';
  disabled?: boolean;
  children?: React.ReactNode;
}

// Function component
function Button({ label, onClick, variant = 'primary', disabled = false, children }: ButtonProps) {
  return (
    <button
      className={`btn btn-${variant}`}
      onClick={onClick}
      disabled={disabled}
    >
      {children ?? label}
    </button>
  );
}

// Alternative: FC type (less recommended now)
const Button: React.FC<ButtonProps> = ({ label, onClick }) => (
  <button onClick={onClick}>{label}</button>
);

// Component with generics
interface ListProps<T> {
  items: T[];
  renderItem: (item: T) => React.ReactNode;
  keyExtractor: (item: T) => string;
}

function List<T>({ items, renderItem, keyExtractor }: ListProps<T>) {
  return (
    <ul>
      {items.map(item => (
        <li key={keyExtractor(item)}>{renderItem(item)}</li>
      ))}
    </ul>
  );
}

// Usage
<List 
  items={users} 
  renderItem={user => <span>{user.name}</span>}
  keyExtractor={user => user.id.toString()}
/>
```

---

## 2. Hooks

**Type hooks properly:**

```tsx
// useState
const [count, setCount] = useState(0);                    // Inferred as number
const [user, setUser] = useState<User | null>(null);     // Explicit union
const [items, setItems] = useState<string[]>([]);         // Empty array needs type

// useRef
const inputRef = useRef<HTMLInputElement>(null);
const countRef = useRef(0);  // Mutable ref, inferred as number

// useEffect - no special typing needed
useEffect(() => {
  const handler = () => console.log('scroll');
  window.addEventListener('scroll', handler);
  return () => window.removeEventListener('scroll', handler);
}, []);

// useMemo/useCallback
const expensiveValue = useMemo(() => computeExpensive(data), [data]);
const handleClick = useCallback((event: React.MouseEvent) => {
  console.log(event.currentTarget);
}, []);

// useReducer
interface State {
  count: number;
  loading: boolean;
}

type Action = 
  | { type: 'increment' }
  | { type: 'decrement' }
  | { type: 'setLoading'; payload: boolean };

function reducer(state: State, action: Action): State {
  switch (action.type) {
    case 'increment':
      return { ...state, count: state.count + 1 };
    case 'decrement':
      return { ...state, count: state.count - 1 };
    case 'setLoading':
      return { ...state, loading: action.payload };
  }
}

const [state, dispatch] = useReducer(reducer, { count: 0, loading: false });
```

---

## 3. Event Handling

**Type events correctly:**

```tsx
// Form events
function handleSubmit(event: React.FormEvent<HTMLFormElement>) {
  event.preventDefault();
  const formData = new FormData(event.currentTarget);
}

// Input change
function handleChange(event: React.ChangeEvent<HTMLInputElement>) {
  setValue(event.target.value);
}

// Select change
function handleSelect(event: React.ChangeEvent<HTMLSelectElement>) {
  setOption(event.target.value);
}

// Click events
function handleClick(event: React.MouseEvent<HTMLButtonElement>) {
  console.log(event.currentTarget.name);
}

// Keyboard events
function handleKeyDown(event: React.KeyboardEvent<HTMLInputElement>) {
  if (event.key === 'Enter') {
    submit();
  }
}

// Focus events
function handleFocus(event: React.FocusEvent<HTMLInputElement>) {
  console.log('Focused:', event.target.name);
}

// Drag events
function handleDrop(event: React.DragEvent<HTMLDivElement>) {
  event.preventDefault();
  const files = event.dataTransfer.files;
}
```

---

## 4. Context

**Type context properly:**

```tsx
// Context type
interface AuthContextType {
  user: User | null;
  login: (email: string, password: string) => Promise<void>;
  logout: () => void;
  loading: boolean;
}

// Create context with undefined default
const AuthContext = createContext<AuthContextType | undefined>(undefined);

// Provider component
function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);

  const login = async (email: string, password: string) => {
    const user = await authService.login(email, password);
    setUser(user);
  };

  const logout = () => {
    authService.logout();
    setUser(null);
  };

  return (
    <AuthContext.Provider value={{ user, login, logout, loading }}>
      {children}
    </AuthContext.Provider>
  );
}

// Custom hook with type guard
function useAuth(): AuthContextType {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAuth must be used within AuthProvider');
  }
  return context;
}

// Usage
function Profile() {
  const { user, logout } = useAuth(); // Fully typed
  return <div>{user?.name}</div>;
}
```

---

## 5. Props Patterns

**Common prop patterns:**

```tsx
// Children prop
interface ContainerProps {
  children: React.ReactNode;  // Anything renderable
}

// Render prop
interface DataLoaderProps<T> {
  url: string;
  render: (data: T, loading: boolean) => React.ReactNode;
}

// Component prop
interface LayoutProps {
  header?: React.ComponentType<{ title: string }>;
  footer?: React.ReactElement;
}

// Spread HTML attributes
interface InputProps extends React.InputHTMLAttributes<HTMLInputElement> {
  label: string;
  error?: string;
}

function Input({ label, error, ...inputProps }: InputProps) {
  return (
    <div>
      <label>{label}</label>
      <input {...inputProps} />
      {error && <span className="error">{error}</span>}
    </div>
  );
}

// Polymorphic component
interface BoxProps<T extends React.ElementType> {
  as?: T;
  children: React.ReactNode;
}

type PolymorphicProps<T extends React.ElementType> = BoxProps<T> & 
  Omit<React.ComponentPropsWithoutRef<T>, keyof BoxProps<T>>;

function Box<T extends React.ElementType = 'div'>({
  as,
  children,
  ...props
}: PolymorphicProps<T>) {
  const Component = as || 'div';
  return <Component {...props}>{children}</Component>;
}

// Usage
<Box as="section" className="container">Content</Box>
<Box as="a" href="/link">Link</Box>
```

---

## 6. Forms

**Type form handling:**

```tsx
interface FormData {
  email: string;
  password: string;
  rememberMe: boolean;
}

function LoginForm() {
  const [formData, setFormData] = useState<FormData>({
    email: '',
    password: '',
    rememberMe: false
  });

  const handleChange = (
    event: React.ChangeEvent<HTMLInputElement>
  ) => {
    const { name, value, type, checked } = event.target;
    setFormData(prev => ({
      ...prev,
      [name]: type === 'checkbox' ? checked : value
    }));
  };

  const handleSubmit = async (event: React.FormEvent) => {
    event.preventDefault();
    await login(formData);
  };

  return (
    <form onSubmit={handleSubmit}>
      <input
        name="email"
        type="email"
        value={formData.email}
        onChange={handleChange}
      />
      <input
        name="password"
        type="password"
        value={formData.password}
        onChange={handleChange}
      />
      <label>
        <input
          name="rememberMe"
          type="checkbox"
          checked={formData.rememberMe}
          onChange={handleChange}
        />
        Remember me
      </label>
      <button type="submit">Login</button>
    </form>
  );
}
```

---

## 7. Custom Hooks

**Type custom hooks:**

```tsx
// Return tuple (like useState)
function useToggle(
  initialValue = false
): [boolean, () => void, (value: boolean) => void] {
  const [value, setValue] = useState(initialValue);
  const toggle = useCallback(() => setValue(v => !v), []);
  return [value, toggle, setValue];
}

// Return object
interface UseFetchResult<T> {
  data: T | null;
  loading: boolean;
  error: Error | null;
  refetch: () => void;
}

function useFetch<T>(url: string): UseFetchResult<T> {
  const [data, setData] = useState<T | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<Error | null>(null);

  const refetch = useCallback(async () => {
    setLoading(true);
    try {
      const response = await fetch(url);
      const json = await response.json();
      setData(json);
    } catch (err) {
      setError(err instanceof Error ? err : new Error('Unknown error'));
    } finally {
      setLoading(false);
    }
  }, [url]);

  useEffect(() => {
    refetch();
  }, [refetch]);

  return { data, loading, error, refetch };
}

// Usage
const { data: users, loading, error } = useFetch<User[]>('/api/users');
```

---

## 8. Styling

**Type CSS-in-JS patterns:**

```tsx
// Inline styles
const style: React.CSSProperties = {
  display: 'flex',
  alignItems: 'center',
  backgroundColor: 'blue' // Autocomplete works
};

// CSS Modules
import styles from './Button.module.css';

function Button() {
  return <button className={styles.button}>Click</button>;
}

// Styled-components
interface ButtonStyleProps {
  $variant: 'primary' | 'secondary';
  $size?: 'sm' | 'md' | 'lg';
}

const StyledButton = styled.button<ButtonStyleProps>`
  background: ${props => props.$variant === 'primary' ? 'blue' : 'gray'};
  padding: ${props => props.$size === 'lg' ? '16px' : '8px'};
`;
```

---

## Quick Reference

```tsx
// Common types
React.ReactNode           // Anything renderable
React.ReactElement        // JSX element
React.FC<Props>           // Function component (deprecated style)
React.ComponentType<P>    // Class or function component
React.CSSProperties       // Inline styles object
React.RefObject<T>        // For useRef

// Event types
React.ChangeEvent<HTMLInputElement>
React.FormEvent<HTMLFormElement>
React.MouseEvent<HTMLButtonElement>
React.KeyboardEvent<HTMLInputElement>

// Generics with children
PropsWithChildren<Props>  // Adds children prop
```
]]>