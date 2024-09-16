//Helper function to assist with shuffling arraylists in Tournament class

ArrayList<Integer> shuffle(ArrayList<Integer> in) {
  ArrayList<Integer> shuffledArray = new ArrayList<Integer>();
  int size = in.size();
  
  //shuffle an array by randomly choosing an item from the original, adding it to the outputted array, then remove it from original to not pick again
  for (int i = 0; i < size; i++) {
    int random = int(random(in.size()));
    shuffledArray.add(in.get(random));
    in.remove(in.get(random));  
  }
  
  return shuffledArray;
}
