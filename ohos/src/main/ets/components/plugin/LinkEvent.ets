export class LinkEvent<T> {
  public constructor() {
  }

  private _type: string | undefined | null;

  public set type(value: string | undefined | null) {
    this._type = value;
  }

  public get type(): string | undefined | null {
    return this._type;
  }

  private _payload: T | undefined | null;

  public set payload(value: T | undefined | null) {
    this._payload = value;
  }

  public get payload(): T | undefined | null {
    return this._payload;
  }
}