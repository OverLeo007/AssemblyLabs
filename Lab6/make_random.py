from random import randint


def print_arr(arr, m):
    for i, el in enumerate(arr):
        print(el, end=" ")
        if (i + 1) % m == 0:
            print()


def write(file_name='array.bin', byte_order="little"):

    n, m = map(int, input("Введите через пробел N строк M столбцов\n").split())
    # n, m = randint(3, 7), randint(3, 7)
    # n, m = 6, 3

    numbers = [randint(10, 99) for _ in range(n * m)]
    print("Сгенерировано:")
    print(f"{n = } {m = }")
    print_arr(numbers, m)

    with open(file_name, "wb") as file:
        file.write(n.to_bytes(1, byte_order))
        file.write(m.to_bytes(1, byte_order))
        for num in numbers:
            file.write(num.to_bytes(1, byte_order))
    input("Press enter to close\n")


def test_read(file_name='array.bin', byte_order="little"):
    with open(file_name, 'rb') as file:
        r_n = int.from_bytes(file.read(1), byte_order)
        r_m = int.from_bytes(file.read(1), byte_order)
        r_numbers = [int.from_bytes(file.read(1), byte_order) for _ in range(r_n * r_m)]

    print(f"n = {r_n} m = {r_m}")
    print_arr(r_numbers, r_m)


def main():
    file_name = 'array.bin'
    byte_order = "little"

    write(file_name, byte_order)

    # test_read(file_name, byte_order)


if __name__ == '__main__':
    main()
