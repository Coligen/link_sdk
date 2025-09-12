export class LinkEvent<T> {
  public static TYPE_CONNECTION_STATE: number = 0;
  public static TYPE_NOTIFY: number = 1;
  public static TYPE_PROGRESS: number = 1;

  public constructor() {
  }

  private _type: number | undefined | null;

  public set type(value: number | undefined | null) {
    this._type = value;
  }

  public get type(): number | undefined | null {
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