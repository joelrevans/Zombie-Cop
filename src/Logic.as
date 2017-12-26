package 
{
	
	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	public class Logic 
	{
		/*Given a list of numbers, returns anohter list with instructions on how to order them.  Each index specifies the new position of the number at that index.*/
		public static function binaryAscendingSort(numbers:Array):Array {
			var w:Array = new Array();	//stores ordered values
			var ini:uint;	//beginning of possible indicies
			var fin:uint;//end of possible indicies
			var index:uint;	//working var.  Stores current index locations.
			for (var a:uint = 0; a < numbers.length; a++) {
				if (numbers[a] < numbers[w[0]]) {
					w.unshift(a);
					continue;
				}
				fin = w.length;
				ini = 0;
				while (fin - ini > 1) {
					index = Math.floor((fin - ini) / 2) + ini;
					if (numbers[a] >= numbers[w[index]]) {
						ini = index;
					}else{
						fin = index; //less than or equal to fin
					}
				}
				//insert after ini
				w.splice(ini + 1, 0, a);
			}
			return w;
		}
		/*Adds a single number into a sorted array, rather than recalculating the whole array.  Does not return an array, only the index with which to .splice() into.
		 * @param numberToAdd A number to place into the array.
		 * @param sortedArray An array with a binaryAscendingSort applied to it.*/
		public static function appendBinaryAscendingSort(numberToAdd:Number, sortedArray:Array):uint {
			//This function is literally a copy of the code from binaryAscending sort, minus the for loop.
			if (numberToAdd < sortedArray[0]) {
				return 0;
			}
			var fin:uint = sortedArray.length;
			var ini:uint = 0;
			var index:uint;	//working var
			while (fin - ini > 1) {
				index = Math.floor((fin - ini) / 2) + ini;
				if (numberToAdd >= sortedArray[index]) {
					ini = index;
				}else {
					fin = index; //less than or equal to fin
				}
			}
			return ini + 1;
		}
		/*Returns a copy of the provided array in reverse order.*/
		public static function reverseArray(array:Array):Array {
			var r:Array = new Array();	//working array
			for (var i:uint = 0; i < array.length; i++) {
				r.unshift(array[i]);
			}
			return r;
		}
		/*Applies a sorting list to an array, original remains unmodified.
		 * @param The array to manipulate.
		 * @param The sorting list, containing the new locations of every item in the array.  Unspecified items will be ignored.*/
		public static function applySort(array:Array, sortList:Array):Array {
			var w:Array = new Array();//working array
			for (var i:uint = 0; i < sortList.length; i++) {
				w[i] = array[sortList[i]];
			}
			return w;
		}
	}
	
}