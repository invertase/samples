export interface RawValue {
  [key: string]: any;
}

export interface Movie {
  id: RawValue;
  name: RawValue;
  description: RawValue;
}

export interface Page {
  current: number;
  total_pages: number;
}

export interface Meta {
  page: Page;
}

export interface Movies {
  results: Movie[];
  meta: Meta;
}
